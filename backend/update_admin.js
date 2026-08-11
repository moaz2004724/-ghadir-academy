import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const prisma = new PrismaClient();

async function updateAdminCredentials() {
  const newEmail = 'admin@ghadirsports.sa';
  const newPassword = 'Ghadir@2026!';

  console.log('Updating Admin credentials in PostgreSQL database...');

  try {
    // 1. Update all ADMIN and SUPER_ADMIN user passwords to newPassword
    const updatedCount = await prisma.user.updateMany({
      where: {
        role: { in: ['ADMIN', 'SUPER_ADMIN'] }
      },
      data: {
        password: newPassword
      }
    });

    console.log(`Updated passwords for ${updatedCount.count} admin user(s).`);

    // 2. Delete any old admin test users with obsolete emails if needed or update main admin user
    const existingMainAdmin = await prisma.user.findFirst({
      where: {
        OR: [
          { email: newEmail },
          { id: 'admin' },
          { id: 'royal-admin-id' },
          { id: 'ghadir-admin-id' }
        ]
      }
    });

    if (existingMainAdmin) {
      await prisma.user.update({
        where: { id: existingMainAdmin.id },
        data: {
          email: newEmail,
          password: newPassword,
          name: 'مدير الأكاديمية'
        }
      });
    } else {
      await prisma.user.create({
        data: {
          id: 'admin',
          email: newEmail,
          password: newPassword,
          role: 'ADMIN',
          name: 'مدير الأكاديمية'
        }
      });
    }

    // 3. Make sure any other admin user records also have updated password
    await prisma.user.updateMany({
      where: {
        role: 'ADMIN'
      },
      data: {
        password: newPassword
      }
    });

    console.log('Admin user updated successfully to email:', newEmail);
  } catch (error) {
    console.error('Failed to update admin credentials:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

updateAdminCredentials();
